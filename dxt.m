function Dxt = dxt(U)
    Dxt = [U(:,end) - U(:,1), -diff(U, 1, 2)];
end