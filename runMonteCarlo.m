function results = runMonteCarlo(data, runnable)

Mc = data.Mc;
cycles = data.movementCycles;

results = nan(Mc * cycles, 2);

for i = 1:Mc
    runData = data;
    range = (i-1)*901+1:i*901;
    runData.energies = data.energies(range,:);
    
    results((i-1)*cycles+1 : i*cycles, :) = runnable(runData);
end

end

