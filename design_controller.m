s = tf('s');

% given continous transfer function
d = 2; 	  % delay
G = exp(-d*s) / ((5 * s + 1) * (2 * s + 1))

% design requirements
ks = 2;   % gain
Ts = 1;   % sampling interval
Mp = 0.1; % overshoot
Tn = 5;   % rise time

k = 1 + d * Ts;      						% delay
omega_n = 1.8 / Tn;  						% natural frequency
zeta = -log(Mp) / sqrt(pi^2 + (log(Mp))^2); % damping coefficient

% dicrete transfer function
z = tf('z', Ts);
Gz = c2d(G, Ts, 'zoh')

% desired transfer functions
Gm = ks * (omega_n)^2 / (s^2 + 2*zeta*omega_n*s + omega_n^2)
Gmz = c2d(Gm, Ts, 'zoh')

% get polynomials from tf
[B, A] = tfdata(Gz, 'v')
[Bm, Am] = tfdata(Gmz, 'v')

% split B+ and B-
B_plus = B(2);
B_minus = [1 B(3)/B(2)];

% prescale Bm
expected = ks*sum(Am)/sum(B_minus);
actual = sum(Bm);
factor = actual / expected;
Bm = Bm / factor;

% add noise
Ag = [1 -1];
AAg = conv(A, Ag);

% calculate polynomials rank
nF = k - 1 + get_n(B_minus);
nG = max(get_n(A)+get_n(Ag)-1, get_n(Am)-k-get_n(B_minus));

% build Sylvester and result matrices
sylvester = zeros(nF+nG+1);
for i=1:nF
    sylvester(i:(i+get_n(AAg)), i) = AAg';
end
for i=nF:nF+nG
    sylvester(i:(i+get_n(B_minus)), i+1) = B_minus';
end

result = zeros(nF+nG+1,1);
result(1:get_n(Am)) = Am(2:length(Am));
result(1:get_n(AAg)) = result(1:get_n(AAg)) - AAg(2:length(AAg))';

% solve Diophantine equation
x = sylvester\result;
F = [1; x(1:nF)];
G = x(nF+1:nF+nG+1);

% build RST polynomials
R = conv(B_plus*Ag,F)
S = G
T = Bm'

% =========================================================================
function n = get_n(A)
    n = length(A) - 1;
end