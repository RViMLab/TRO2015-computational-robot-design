# CTR Project Documentation
###This file contains the documentation for the CTR project code.
####run_optimization.m

Loads all the data
```
anatomy.filename = ['../../data/' scenario '/anatomy.mat'];
....
```
define the optimization variables and optimization method i.e. fminsearchbnd
```
mopts.variables = {'lengths_curved', 'curvatures', 'base'};
mopts.method = 'fminsearchbnd';
```

__to be confirmed__ 
targets = targets([2 3 4 5 6 7 1 8 9 10 11 12 13], :);

H is end-effector _but need to understand line 53-56_

Creates an array of CTR
```
ctr_ = [];
```
And add the below CTRs of Balance and Fixed type to ctr_ array

Creates concentric tube robots signature of **Balance** type.Balanced pair is 2 curved sgments and 2 straight segments
```

i = 1;
ctr_(i).type      = 'balanced';
```
Creates concentric tube robots signature of **Fixed** type. Fixed curvature tube is a straight segment and a curved segment.
```
i = 2;
ctr_(i).type      = 'fixed';

ctr_(i).u         = 45;
ctr_(i).u_min     = 0;
```
**Attributes of CTR**:
* Id
* U		curvature
* Length	arclength
* K		stiffness
* Diameter	
* Theta		need to write
* Phi		need to write
* Start		arc start
* End		arc end
* Curve		holds the curve

The array ctr_ is passed to CTROptimize
```
[ctr_ err] = CTROptimize(ctr_, H, anatomy, targets, vector, base, mopts);
```

####CTRCreateStructure.m
This file will receive CTR signature structure and populates all the parameters based on relationships between the tubes
S: The potential curvature changing points that should be examined.**Need to clarify**

A balanced pair is created with 4 segments(2 curved segments and 2 straight segments). A fixed curvature tube is created with 2 segments(1 straight and 1 curved segment) and number of segment is set accordingly as below:
length(ctr_) = 3 as being passed from run_optimization.m
```
for i = 1:length(ctr_)
    if strcmp(ctr_(i).type, 'balanced')
      n_segments = n_segments + 4;
    elseif strcmp(ctr_(i).type, 'fixed')
      n_segments = n_segments + 2;
    end
  end
```
A struct is created with all the attributes of CTR
```
ctr = CTRCreateSegment();
```
i is used to iterate new structure and j for old structure
If n_segment = 4( 'Balanced' type) the below iterates 1 time and initialises the new struct as below:
3rd element in new struct = first element in the old struct
4th element in new struct = same as 3rd element in new struct except theta and k are overwritten
```
ctr(i+2).id       = i + 2;
      ctr(i+2).u        = ctr_(j).u;
      ctr(i+2).u_temp   = ctr_(j).u;
      ctr(i+2).length   = ctr_(j).c_len;
      ctr(i+2).k        = ctr_(j).k(1);
      ctr(i+2).k_temp   = ctr_(j).k(1);
      ctr(i+2).diameter = ctr_(j).diameter;
      ctr(i+2).theta    = ctr_(j).theta(1);
      ctr(i+2).phi      = max(0, min(ctr_(j).phi, ctr_(j).c_len));
      ctr(i+2).start    = max(0, ctr(i+2).phi + all_end - ctr(i+2).length);
      ctr(i+2).end      = ctr(i+2).phi + all_end;
      
      % Curved segment #2
      ctr(i+3)       = ctr(i+2);
      ctr(i+3).id    = i+3;
      ctr(i+3).theta = ctr_(j).theta(2);
      if length(ctr_(j).k) == 2
        ctr(i+3).k = ctr_(j).k(2);
      end
```
The first element in new strcut has the stiffness, diameter and theta same as first element in old struct
Length is set as diff between arc end and arc length for 3rd element
```
	ctr(i).id       = i;
	ctr(i).u        = 0;
	ctr(i).u_temp   = 0;
	ctr(i).length   = max(0, ctr(i+2).end - ctr(i+2).length);
	ctr(i).k        = ctr_(j).k(1);
	ctr(i).k_temp   = ctr_(j).k(1);
	ctr(i).diameter = ctr_(j).diameter;
	ctr(i).theta    = ctr_(j).theta(1);
	ctr(i).phi      = NaN;
	ctr(i).start    = 0;
	ctr(i).end      = ctr(i).length;
```
The second element is the same as first element except for the value of theta and k

** Why we are taking the unique s?**
```
s = unique(s);
```

###CTRCreateCTRFromFile
CTRCREATECTRFROMFILE reads the data from DIREC for iteration IND and creates a simple concentric tube robot CTR_ and also return the base location.

The below code loads the file from direc, selects the ctr as per target_idx and pass it on to CTRCreateSimpleCTRFromFullCTR.
```
load([direc, files(ind).name]);
  ctr_selected = ctr{target_idx};
  HT = base;
  
  ctr_simple = CTRCreateSimpleCTRFromFullCTR(ctr_selected);
```

###CTRCreateSimpleCTRFromFullCTR.m
This is invoked from CTRCreateCTRFromFile.m,which read the data file and loads the full ctr. The full ctr is passed to CTRCreateSimpleCTRFromFullCTR to get a compact version of CTR
```
while i <= n_segments
    
    if isnan(phis(i))
      if isnan(phis(i+1))
        simple_ctr_segments = simple_ctr_segments + 1;
        simpleCTR(simple_ctr_segments).type      = 'balanced';

        simpleCTR(simple_ctr_segments).u         = fullCTR(i+2).u;
        simpleCTR(simple_ctr_segments).c_len     = fullCTR(i+2).length;
        
        simpleCTR(simple_ctr_segments).k         = fullCTR(i+2).k;
        simpleCTR(simple_ctr_segments).diameter  = fullCTR(i+2).diameter;
        simpleCTR(simple_ctr_segments).theta     = [thetas(i+2) thetas(i+3)];
        simpleCTR(simple_ctr_segments).phi       = phis(i+2);
        
        i = i + 4;
      else
        simple_ctr_segments = simple_ctr_segments + 1;
        simpleCTR(simple_ctr_segments).type      = 'fixed';

        simpleCTR(simple_ctr_segments).u         = fullCTR(i+1).u;
        simpleCTR(simple_ctr_segments).c_len     = fullCTR(i+1).length;
        
        simpleCTR(simple_ctr_segments).k         = fullCTR(i+1).k;
        simpleCTR(simple_ctr_segments).diameter  = fullCTR(i+1).diameter;
        simpleCTR(simple_ctr_segments).theta     = thetas(i+1);
        simpleCTR(simple_ctr_segments).phi       = phis(i+1);
        
        i = i + 2;
      end
    end
```
2 NaN phis means the full ctr is a balanced one. In case of 1 NaN phi it means the full ctr is of fixed type.
__but is 3rd element of full_ctr is copied to the first element of simple ctr? as in line -
 ```simpleCTR(simple_ctr_segments).u = fullCTR(i+2).u;```

 ###CTRCreateMinimizationVectorFromCTR
 CTRCREATEMINIMIZATIONVECTORFROMCTR(CTR, MOPTS) creates a minimization vector given a concentric tube robot CTR and directions on what to minimize for MOPTS. A simple CTR is input to this method.

Loops through mopts( array of string containing optimization parameters- length , lengths_curved, curvatures)
and populates attributes of x_ with values from ctr e.g. x_.lengths_curved = [ctr(:).c_len]
```
for i = length(mopts):-1:1
    switch mopts{i}
      case 'lengths'
        x_.lengths = zeros(1, 2*length(ctr));
        for j = 1:length(ctr)
          x_.lengths(2*j-1:2*j) = [ctr(j).s_len; ctr(j).c_len];
        end
      case 'lengths_curved'
        x_.lengths_curved = [ctr(:).c_len];
      case 'curvatures'
        x_.curvatures = zeros(1, length(ctr));
        for j = 1:length(ctr)
          x_.curvatures(j) = ctr(j).u;
        end
      case 'base'
        x_.base = HG(:);
    end
  end
```  
```
Issue - 
1. why is length is initialised with 1 X 2*length size?
2. x_.lengths(2*j-1:2*j) = [ctr(j).s_len; ctr(j).c_len]
```

The below code is vectorizing the optimization parameters. Question:
As all the below isfield() may return true, in that case what will be the structure x look like, will
the value be replaced with each isfield() check?
```
if isfield(x_, 'lengths')
    x = [x; x_.lengths(:)];
  end
  if isfield(x_, 'lengths_curved')
    x = [x; x_.lengths_curved(:)];
  end
  if isfield(x_, 'curvatures')
    x = [x; x_.curvatures(:)];
```
####CTRCreateCTRFromMinimizationVector
The minimization vector return by the above method CTRCreateMinimizationVectorFromCTR is read by this method. A simple ctr and mopts(string array of optimization params)are also an input to this method.

mopts is updated with sorted value of mopts and ctr is initialised with simple ctr(ctr_)
```
mopts = sort(mopts); 
ctr = ctr_
```
Issue - 
Not able to understand the logic for updating ctr with ctr_




