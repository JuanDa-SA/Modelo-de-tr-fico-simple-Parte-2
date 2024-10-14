using Agents, Random
using StaticArrays: SVector

@agent struct Car(ContinuousAgent{2,Float64})
    accelerating::Bool = true
end

# @agent struct Semaforo(GridAgent{2})
    

accelerate(agent) = agent.vel[1] + 0.05
decelerate(agent) = agent.vel[1] - 0.1


function car_ahead(agent, model)
    for neighbor in nearby_agents(agent, model, 1.0)
        if neighbor.pos[1] > agent.pos[1]
            return neighbor
        end
    end
    nothing
end

counter = 0

function  agent_step!(agent, model)
    global counter
    new_velocity = isnothing(car_ahead(agent, model)) ? accelerate(agent) : decelerate(agent)

    
    if new_velocity >= 1.0
        new_velocity = 1.0
        agent.accelerating = false
    elseif new_velocity <= 0.0
        new_velocity = 0.0
        agent.accelerating = true
    end
    
    agent.vel = (new_velocity, 0.0)
    move_agent!(agent, model, 0.4)
end


# @agent struct Car(ContinuousAgent{2,Float64})
# end

# function agent_step!(agent, model)
#     move_agent!(agent, model, 1.0)
# end

function initialize_model(extent = (25, 10))
    space2d = ContinuousSpace(extent; spacing = 0.5, periodic = true)
    rng = Random.MersenneTwister()

    model = StandardABM(Car, space2d; rng, agent_step!, scheduler = Schedulers.Randomly())

    first = true
    py = 1.0
    for px in randperm(25)[1:10]
        if first
            add_agent!(SVector{2, Float64}(px, 0), model; vel=SVector{2, Float64}(1.0, 0.0))
        else
            add_agent!(SVector{2, Float64}(px, 0), model; vel=SVector{2, Float64}(rand(Uniform(0.2, 0.7)), 0.0))
        end
        first = false
        py += 2.0
    end
    model
end

#v1
# function initialize_model(extent = (25, 10))
#     space2d = ContinuousSpace(extent; spacing = 0.5, periodic = true)
#     rng = Random.MersenneTwister()

#     model = StandardABM(Car, space2d; rng, agent_step!, scheduler = Schedulers.Randomly())

#     for px in randperm(25)[1:8]
#         add_agent!(SVector{2, Float64}(px, 0.0), model; vel=SVector{2, Float64}(rand(Uniform(0.2,0.7)), 0.0))
#     end
#     model
# end

# function initialize_model(extent = (25, 10))
#     space2d = ContinuousSpace(extent; spacing = 0.5, periodic = true)
#     rng = Random.MersenneTwister()

#     model = StandardABM(Car, space2d; rng, agent_step!, scheduler = Schedulers.Randomly())

#     for px in randperm(25)[1:9] #Cambiamos coches
#         add_agent!(SVector{2, Float64}(px, 0.0), model; vel=SVector{2, Float64}(rand(Uniform(0.2,0.7)), 0.0))#Diferentes velocidades

#         print(SVector{2, Float64}(px, 0.0))
#     end
#     model

