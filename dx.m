function Dx = dx(U)
    Dx = [diff(U, 1, 2), U(:,1) - U(:,end)];
end