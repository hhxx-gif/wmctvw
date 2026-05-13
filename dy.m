function Dy = dy(U)
    Dy = [diff(U, 1, 1); U(1,:) - U(end,:)];
end