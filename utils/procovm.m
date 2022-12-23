function Q = procovm(q, dt)
%PROCOVM Creates the process noise covariance matrix Q

Q = q * [dt^3/3, 0, dt^2/2, 0; ...
                0, dt^3/3, 0, dt^2/2; ...
                dt^2/2, 0, dt, 0; ...
                0, dt^2/2, 0, dt];  

end

