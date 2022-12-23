function json2mat()

for n = 3:3:15
  for var = 80:-5:40
    load("TrajetotyN"+n+"V"+var+"dB.json");
    simulations = jsondecode(Param);
    save("TrajetotyN"+n+"V"+var+"dB.mat", ...
      'simulations');
  end
end