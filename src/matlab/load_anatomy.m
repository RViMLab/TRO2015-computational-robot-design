function anatomy = load_anatomy(filename)
%
% FUNCTION
%   LOAD_ANATOMY reads FILENAME and returns the points PTS, triangles TRI,
%   and binary data BINARY.
%
% USAGE
%   ANATOMY = LOAD_ANATOMY(FILENAME).
%
% INPUT
%   FILENAME: The path to the anatomy file.
%
% OUTPUT
%   ANATOMY: Contains PTS, TRI, BINARY, KDTREE, NORMALS, NORMALSF, SPLINE,
%   SPLINE_VECTORS.
%
%   PTS: Vertices of the anatomy model.
%   TRI: Triangles of the anatomy model.
%   BINARY: Binary (logical) map of the anatomy model.
%   KDTREE: A KD-tree of the anatomy for collision detection.
%   NORMALS: The surface normals at each vertex.
%   NORMALSF: The surface normals at each face.
%   SPLINE: spline of the jugular for proximal/navigation
%   SPLINE_vectors = normalized vectors along the lenght of the spline
%
% AUTHOR
%   Christos Bergeles
%
% DATE
%   2012.08.06
%
  
  if nargin < 1
    error('LOAD_ANATOMY: One input argument is required.');
  end
  
  load(filename);

  data = FV;
  
  Pts = FV.vertices;
  Tri = FV.faces;
  
  if exist('spline_points_atrium2jug', 'var')
    spline = spline_points_atrium2jug;
  else
    spline = [];
  end
  if exist('spline_vecs_atrium2jug', 'var')
    spline_vectors = spline_vecs_atrium2jug;
  else
    spline_vectors = [];
  end
  if ~isempty(spline)
    kdtree = KDTree(Pts);
  end
  
  [normal, normalf] = compute_normal(Pts, Tri);
  
  anatomy.pts = Pts;
  anatomy.tri = Tri;
  if ~exist('Binary', 'var')
    Binary = [];
  end
  anatomy.binary = Binary;
  anatomy.row_el = size(Binary, 1);
  anatomy.col_el = size(Binary, 2);
  anatomy.dep_el = size(Binary, 3);
  if ~isempty(spline)
    anatomy.kdtree = kdtree;
  end
  anatomy.normals = normal;
  anatomy.normalsf = normalf;
  anatomy.spline = spline;
  anatomy.spline_vectors = spline_vectors;
  
  anatomy.filename = filename;
  
end