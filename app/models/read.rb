require 'csv'

module Read
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


end
