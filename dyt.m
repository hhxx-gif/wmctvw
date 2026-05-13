function Dyt = dyt(U)
    Dyt = [U(end,:) - U(1,:); -diff(U, 1, 1)];
end