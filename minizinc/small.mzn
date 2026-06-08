% ===== TMLPA - Instancia Pequeña =====
% 5 clientes, 3 hubs

int: n_clientes = 5;
int: n_hubs = 3;

% Distancias cliente-hub
array[1..n_clientes, 1..n_hubs] of int: d =
  [| 5,  8, 11
   | 7,  4, 10
   | 10, 8,  6
   | 9,  5,  7
   | 8,  9,  5 |];

% Costos fijos de cada hub
array[1..n_hubs] of int: f = [20, 25, 15];

% Costos operativos de cada hub
array[1..n_hubs] of float: o = [0.8, 1.2, 0.6];

% Capacidades de cada hub
array[1..n_hubs] of int: L = [6, 8, 7];

% Demandas de cada cliente
array[1..n_clientes] of int: q = [2, 3, 2, 3, 2];

% Prioridades de cada cliente
array[1..n_clientes] of float: w = [1.0, 1.5, 0.8, 1.2, 1.0];

int: d_max = 8;
int: P = 2;
int: P_min = 1;

% ===== Variables de decisión =====
% x[c] = hub asignado al cliente c
array[1..n_clientes] of var 1..n_hubs: x;
% y[j] = 1 si el hub j está abierto
array[1..n_hubs] of var 0..1: y;

% ===== Restricciones =====
% R1: cada cliente va a un hub abierto
constraint forall(c in 1..n_clientes)(
    y[x[c]] = 1
);

% R2: capacidad de cada hub
constraint forall(j in 1..n_hubs)(
    sum(c in 1..n_clientes where x[c] = j)(q[c]) <= L[j]
);

% R3: cobertura (distancia máxima)
constraint forall(c in 1..n_clientes)(
    d[c, x[c]] <= d_max
);

% R4: número de hubs abiertos entre P_min y P
constraint P_min <= sum(j in 1..n_hubs)(y[j]) /\ sum(j in 1..n_hubs)(y[j]) <= P;

% ===== Función objetivo =====
var float: costo_instalacion =
    sum(j in 1..n_hubs)(
        f[j] * y[j] + o[j] * sum(c in 1..n_clientes where x[c] = j)(q[c])
    );

var float: costo_caminata =
    sum(c in 1..n_clientes)(
        w[c] * d[c, x[c]]
    );

var float: fo = costo_instalacion + costo_caminata;

solve minimize fo;

output [
    "y (hubs) = ", show(y), "\n",
    "x (clientes) = ", show(x), "\n",
    "Costo instalacion = ", show(costo_instalacion), "\n",
    "Costo caminata = ", show(costo_caminata), "\n",
    "FO optima = ", show(fo), "\n"
];
