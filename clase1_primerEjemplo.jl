
# clase 05/octubre

# Ejemplo 1.
# paqueterias
using CPLEX, JuMP

# Preparación del modelo a optimizar
m = Model(CPLEX.Optimizer)

# Declaración de variables
@variable(m, 0<= x1 <=10)
@variable(m, x2 >=0)
@variable(m, x3 >=0)

# Construcción de la función objetivo
@objective(m, Max, x1 + 2x2 + 5x3)

# Restricciones del problema
@constraint(m, constraint1, -x1 +  x2 + 3x3 <= -5)
@constraint(m, constraint2,  x1 + 3x2 - 7x3 <= 10)

# imprimimos el modelo construido
print(m)

# optimizador del modelo
JuMP.optimize!(m)

# Impresión de soluciones de las variables para el problema primal
println("Optimal Solutions:")
println("x1 = ", JuMP.value(x1))
println("x2 = ", JuMP.value(x2))
println("x3 = ", JuMP.value(x3))

#------------------------------------------------------------------------------
#forma dos de escribir el problema
m = Model(CPLEX.Optimizer)

c = [ 1; 2; 5]
A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

@variable(m, x[1:3] >= 0)
@objective(m, Max, sum( c[i]*x[i] for i in 1:3) )

@constraint(m, constraint[j in 1:2], sum( A[j,i]*x[i] for i in 1:3 ) <= b[j] )
@constraint(m, bound, x[1] <= 10)

JuMP.optimize!(m)


println("Soluciones optimas:")
for i in 1:3
  println("x[$i] = ", JuMP.value(x[i]))
end

#------------------------------------------------------------------------------
#Forma 3 de escribir el problema
c = [ 1; 2; 5]
A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

model = Model(CPLEX.Optimizer)

m = size(A,1) # número de renglones de A
n = size(A,2) # número de columnas de A

@variable(model,0 <= x[1:n])
@objective(model,Max,sum(c[j]*x[j] for j in 1:n))
@constraint(model,[i=1:m],sum(A[i,j]*x[j] for j = 1:n) <= b[i])

JuMP.optimize!(model)


println("Soluciones optimas:")
for i in 1:3
  println("x[$i] = ", JuMP.value(x[i]))
end
