require 'set'

module Algo
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



end
