using Flux
MNODE = Chain(x -> [x],
            Dense(1,32,tanh),
            Dense(32,1),
            first)
MNODE(1.0)
g(t)         
