cluster_name = "sample-react-cluster"
# publicly_accessible = true
containers={

    container_1={
        ecs_desired_count = 1  # Number of containers running
        # image_name = "image_name" 
        container_name = "sample-react-app-task"  # ignore
        ecs_service_name = "sample-react-app-service"
        alb_name = "test-alb"
        internal = false
        /* repository_name = "repo-name" */
        
        container_port= 8080 #eg-4000
 

     }
   
}   