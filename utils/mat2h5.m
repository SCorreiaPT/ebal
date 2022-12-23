function mat2h5()
for n = 3:3:15
  for var = 80:-5:40
    load("TrajetotyN"+n+"V"+var+"dB.mat", 'data');
    save("TrajetotyN"+n+"V"+var+"dB.h5.mat", 'data', '-v7.3');
  end
end

end