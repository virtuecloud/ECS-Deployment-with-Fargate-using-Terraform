cluster_name = "cluster-name"
publicly_accessible = true
containers={

    container_1={
        ecs_desired_count = 1  # Number of containers running
        image_name = "image_name" 
        container_name = "container_name"  # ignore
        ecs_service_name = "service-name"
        alb_name = "alb-name"
        internal = true
        /* repository_name = "repo-name" */
        
        container_port= container_port #eg-4000
 

     }
   
}   