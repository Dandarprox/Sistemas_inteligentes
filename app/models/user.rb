require 'csv'
require 'set'


# require_relative './algorithm'
# require_relative './read'
def deepCopy(value)
  return Marshal.load(Marshal.dump(value))
end

def euclidianDistance(a, b)

  distance = 0
  for i in 0..(a.length - 1)
    distance += (a[i] - b[i]) ** 2
  end

  return Math.sqrt(distance)
end

def calcNeighbors(points, q, eps)
  neighbors = []
  for point in points
    if euclidianDistance(q.gustos, point.gustos) <= eps
      neighbors.push(point)
    end
  end

  return neighbors
end

def DBSCAN(points, eps, minPts)
  cluster = 0

  for point in points
    if point.cluster != -1
      next
    end
    neighbors = calcNeighbors(points, point, eps)
    if neighbors.length < minPts
      point.cluster = 'Noise'
      next
    end

    cluster += 1

    point.cluster = cluster

    s = []
    for elem in neighbors
      s.push(elem)
    end

    s = s.uniq

    for q in s
      if q.cluster == 'Noise'
        q.cluster = cluster
      end
      if q.cluster != -1
        next
      end
      q.cluster = cluster
      neighbors = calcNeighbors(points, q, eps)
      if neighbors.length >= minPts
        s += neighbors
        s = s.uniq
      end
    end

  end

end

def k_neighbors(points, k, q)
  nearest = points.sort_by {|x| euclidianDistance([x.animo, x.genero], [q.animo, q.genero])}

  if k < points.length
    return nearest[0..(k - 1)]
  else
    return nearest
  end
end

def file_reading(filename)
  data = []
  CSV.foreach(filename) do | row |
    data.push(row)
  end

  data.shift
  return data
end

def convertGustos(gustos)
  base = ["Cine", "Literatura", "Musica", "Deportes", "Arte", "Tecnologia", "Ciencias exactas", "Gastronomia", "Manualidades", "Ciencias sociales y humanas"]
  coord = []

  for elem in base
    if gustos.include? elem
      coord.push(1)
    else
      coord.push(0)
    end
  end

  return coord
end

def convertGenero(genero)
  base = ["Hombre", "Mujer", "Otro"]
  return base.index(genero)
end

def convertOcupacion(ocupacion)
  base = ["Estudiante", "Trabajador", "Sin ocupacion"]
  coord = []

  for elem in base
    if ocupacion.include? elem
      coord.push(1)
    else
      coord.push(0)
    end
  end

  return coord
end

def convertFisico(fisico)
  base = ["Somnolencia", "Normal", "Enfermedad", "Ejercicio"]
  return base.index(fisico)
end

def convertAnimo(animo)
  base = ["Muy feliz", "Feliz", "Normal", "Triste", "Muy triste"]
  return base.index(animo)
end

class Person

  attr_accessor :genero, :edad, :sleep, :gustos, :ocupacion, :animo, :fisico, :cluster

  def initialize(edad, animo, gustos, genero, ocupacion, fisico, sleep)
    @edad = edad
    @animo = animo
    @gustos = gustos
    @genero = genero
    @ocupacion = ocupacion
    @fisico = fisico
    @sleep = sleep
    @cluster = -1
  end

  def set_cluster(cluster)
    @cluster = cluster
  end

  def to_String()
    print "-------------------", "\n"
    print "> Edad:", @edad, "\n"
    print "> Animo:", @animo, "\n"
    print "> Gustos:", @gustos, "\n"
    print "> Genero:", @genero, "\n"
    print "> Ocupacion:", @ocupacion, "\n"
    print "> Fisico:", @fisico, "\n"
    print "> Sleep:", @sleep, "\n"
    print "> Cluster:", @cluster, "\n"
    print "-------------------", "\n"
  end
end

def generateBasePerson(data)
  people = []

  for person in data
    edad = person[1]
    sleep = person[2]
    animo = convertAnimo(person[3])
    gustos = person[4]
    genero = convertGenero(person[6])
    ocupacion = person[7].strip.split(", ")
    ocupacion = convertOcupacion(ocupacion)
    fisico = convertFisico(person[8])

    gustos = gustos.strip.split(",")
    for i in 0..(gustos.length - 1)
      gustos[i] = gustos[i].strip
    end

    # print ">>>", gustos, "\n"
    gustos = convertGustos(gustos)

    people.push(Person.new(edad, animo, gustos, genero, ocupacion, fisico, sleep))
  end

  return people
end

def generateNewPerson(data)
  people = []

  for person in data
    edad = person[0]
    animo = convertAnimo(person[1])
    gustos = person[2]
    genero = convertGenero(person[3])
    ocupacion = person[4].strip.split(", ")
    ocupacion = convertOcupacion(ocupacion)
    fisico = convertFisico(person[5])
    gustos = gustos.strip.split(",")
    gustos = convertGustos(gustos)
    people.push(Person.new(edad, animo, gustos, genero, ocupacion, fisico, -1))
  end

  return people
end


class User < ApplicationRecord

    def self.to_csv
        attributes = %w{age mood liking gender ocupation physhic}
        titles = %w{Edad Animo Gustos Genero Ocupacion Fisico}

        CSV.generate(headers: true) do |csv|
            csv << titles


            all.each do |user|
                csv << attributes.map{ |attr| user.send(attr) }
            end
        end
    end

    def self.generate_results
      data = file_reading(Rails.root.join("public", "profiling.csv")
)
      otro = []
      User.all.each do |u|
        otro.push([u[:age], u[:mood], u[:liking], u[:gender], u[:ocupation], u[:physhic]])
      end

      people = generateBasePerson(data)
      new_people = generateNewPerson(otro)
      people += new_people

      DBSCAN(people, 1.6, 5)

      c_clusters = Set.new([])
      cluster_info = {}
      cluster_info2 = {}

      for person in people
        if !(cluster_info.include? person.cluster)
          cluster_info[person.cluster] = [person]
          cluster_info2[person.cluster] = 1
        else
          cluster_info[person.cluster].push(person)
          cluster_info2[person.cluster] += 1
        end

        c_clusters.add(person.cluster)
      end

      for new in new_people
        aux_people = deepCopy(cluster_info[new.cluster])

        for i in 0..(aux_people.length)
          if aux_people[i] == new
            aux_people -= aux_people[i]
            break
          end
        end

        neighbors = k_neighbors(aux_people, 3, new)

        avg_sleep = 0
        n_neighbors = neighbors.length

        for n in neighbors
          if n.sleep == -1
            n_neighbors -= 1
            next
          end

          # print "Got this: ", n.sleep, "\n"
          avg_sleep += Integer(n.sleep)
          # print "Vecino duerme: ", n.sleep, "\n"
        end

        new.sleep = avg_sleep * 1.0 / n_neighbors
        # new.to_String()

      end

      return new_people, cluster_info2
    end



end
