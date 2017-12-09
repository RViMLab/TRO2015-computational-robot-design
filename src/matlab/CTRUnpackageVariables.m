function ctr = CTRUnpackageVariables(y, ctr_)

  % Remove kinematic variables from the vector
  ctr = ctr_;
  for i = 1:length(ctr)
    
    ctr(i).theta = y(1:length(ctr(i).theta));
    y(1:length(ctr(i).theta)) = [];
    
    ctr(i).phi = y(1);
    y(1) = [];
    
  end

  if ~isempty(y)
    error('CTRUnpackageVariables: elements remaining.');
  end

end