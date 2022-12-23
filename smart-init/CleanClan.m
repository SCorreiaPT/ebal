function BorderClan = CleanClan(Clan,LW_X, LW_Y, HI_X, HI_Y)

BorderClan = Clan;

for i=1:length(Clan)
    if Clan(i,1)>HI_X
        BorderClan(i,1)=HI_X-(Clan(i,1)-HI_X); 
    end
    if Clan(i,1)<LW_X
        BorderClan(i,1)=LW_X+(LW_X-Clan(i,1)); 
    end
    
    if Clan(i,2)>HI_Y
        BorderClan(i,2)=HI_Y-(Clan(i,2)-HI_Y); 
    end
    if Clan(i,2)<LW_Y
        BorderClan(i,2)=LW_Y+(LW_Y-Clan(i,2)); 
    end
end
end