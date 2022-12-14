/**
* Name: Parking
* Based on the internal empty template. 
* Author: madaliou
* Tags: 
*/


model Parking

/* Insert your model definition here */

/* Insert your model definition here */

global{
		
		file parkingShapeFile <- file("../includes/test.shp");
		//file parkingShapeFile <- file("/Users/madaliou/Documents/qgis/parking/test.shp");
		file voitureImage <- image_file("../includes/data/voiture_rotate.png");
		//file route_shapefile <- file("../includes/lignes.shp");
		file route1_shapefile <- file("../includes/oneRoad.shp");
		file route2_shapefile <- file("../includes/ligneRetour.shp");
		file place_shapefile <- file("../includes/ttttt.shp");
		
		geometry shape <- envelope(parkingShapeFile);
		geometry shape1 <- envelope(route1_shapefile);
		
		int nombre_tour <- 90; //in degree
		int le_facteur <- 10;
		int x;
		float taille <- 2.0;
		int tense <- 500;
	    int intensity <- 2;
	    graph route1;
	    graph route2;
		
		geometry espace_libre;
		
		int nb_voiture <- 20;
		point dest1 <-{10,0};
		
		point dest2 <-{35,0};
		
		init { 
			create Place from: place_shapefile with: [type::int(read ("Poids"))] {
			//write('the place : ', Place.type);
		    	
        }
			
		create Route from: route1_shapefile ;
		route1 <- as_edge_graph(Route);
		create Route from: route2_shapefile;
		route2 <- as_edge_graph(Route);
		
		espace_libre <- copy(shape);
		
		create batiment from: parkingShapeFile {
			
			espace_libre <- espace_libre - (shape + taille);
		}
		
		espace_libre <- espace_libre simplification(1.0);
		
		/*create batiment number: 1 {
		
		} */
		
		/*create Voiture number: 1{
			set location <- dest1;
		} */		
	}
	reflex NewCar when: every (tense/intensity){ 
		
		list neighbour <- list(Place) where(each.occupe=false);
		if(length(neighbour) > 0){
         create Voiture number:1 {
         	location <- dest1;
	        //location <- any_location_in(one_of(shape1));
	        	target <-first(neighbour);
	        	aim <- "Enter";
	        }
         }
         
        }
		
}

species Route  {
	rgb color <- #red ;
	aspect base {
		draw shape color: color ;
	}
}


species batiment {
	
	aspect default {
		draw shape color: #black depth: 0;
	}
}

species name: Voiture skills: [moving]{
	
	rgb color init:rgb(rnd(255), rnd(255), 250+rnd(5));
	//int rayonObservation <- 5;
	int tailleVoiture <- 10+rnd(10);
	bool Garer <- false;
	Place but <- nil;
	//rgb color init: rgb('black');
	//int dureeStationnement <- 0;
	int prix <- 0;
	//point destination <- {200,500};
	//point but <- nil;
	point target <- nil;
	Place goal init: nil;
	string aim <- nil;
	int size init: 10+rnd(8);
	float speed <- 3.0;
	int pauseTime <- 800 + rnd(300);
	int amount <- 0;
    int count <- 0;
    //int parkingSize <- 0;
	
	
	reflex goEnter when: aim="Enter" and target!=nil {
		
		list neighbour <- list(Place) where(each.occupe=false and each.type>=self.size) sort_by ((self distance_to each));
		if(length(neighbour) > 0){
			target <- first(neighbour);
	 		do goto target:first(neighbour) on:route1;
	 		goal <- target;
	 		if(location = target){
	 			ask goal{
	 				set occupe <- true;
	 				myself.target <- nil;
	 			}
	 		}
		}else{
			do goto target:dest2 on:route2;
		}
 		
 		/*
		list neighbour0 <- list(Place) where (each.state="Free" and each.type>self.size);
		write('neighbour', neighour0);
		list neighbour1 <- list(Place) where (each.type="moyen" and each.state="Free");
		list neighbour2 <- list(Place) where (each.type="grand" and each.state="Free");*/
		//write(neighbour);
 		/*if(self.location=target){
 			target <- nil;	
 			if(length(neighbour) > 0){
	            goal <- first(neighbour);
	            aim <- "Park";
	            
	            ask goal {
		        	set state <- "Taken";
		        	set occupe <- true;
	             }
			    }else {
	               target <- dest2;
	               aim <- "retour";
            	}
 		}*/

     		
     }
     
     /*reflex repartir {
     	count <- count+1;
     	//write(count);
		if(count > pauseTime){
			//target <- dest2;
			ask goal{
				//write(occupe);
				set occupe <- false;
	 			//myself.target <- dest2; 
			}
     		do goto target:dest2 on:route2;
     		if(self.location = dest2){
     			do die;
     		}
     	}
     }*/
     
     reflex repartir {
     	count <- count+1;
     	//write(count);
		if(count > pauseTime){
     		do goto target: dest2 on:route2;
     		ask goal{
     			set occupe <- false;
     		}
     		if(self.location = dest2){
     			do die;
     		}
     	}
     }
     
  	/*reflex Garer when:goal!=nil and aim="Garer"{
		do goto target:goal on:route1 speed:speed;
		count <- count+1;
		if(count > pauseTime){
			set aim <- "sortir";
			set target <- dest2;
			ask goal {
				set state <- "Free";
			}
			goal <- nil;
		}

	}
	
	reflex Sortir when:target!=nil and aim="sortir"{
     	do goto target:target on:route1 speed:speed;
     	if(self.location=target){
     		target <- nil;
     		aim <-"partir";
     		amount <- parkingSize * pauseTime;
     		if (amount!=0){
     			target <- any_location_in(one_of(dest2));
     		}
     	}
     }
     
     reflex Sortir_Parking when:target!=nil and aim="partir"{
     	do goto target:target speed:speed;
     	if(self.location=target){
     		do die;
     	}
     }
     
     reflex Retour when:target!=nil and aim="retour"{
     	do goto target:target speed:speed;
     	if(self.location=target){
     		do die;
     	}
     }*/
     	
	
	reflex patrolling{
		//do action: wander amplitude:300;
	}
	aspect base {
		draw circle(size) color:color;
	}
	aspect icon {
		draw voitureImage size: size color: color rotate:heading;
	}
	
	reflex chercherPlace when: (but != nil) {
		//do goto target:target on:route1 speed:speed;
		
		//do action: wander amplitude:200;
		
		
		/*if (length(list (Place) where((self distance_to each) <= rayonObservation)) > 0){
			but <- first(list (Place) where((self distance_to each) <= rayonObservation) sort_by ((self distance_to each) ));
				
		}*/
		
	}
	
	
}

species Place {
	int type; 
	rgb color <- #gray  ;
	bool occupe init: false;
	
	aspect base {
		draw shape color: color ;
	}
	
	/*state Free initial:true{
	}
	
	state Taken{
	}
	reflex verifySize{
		//write(type);
	}*/
}
		


experiment Parking type: gui {
	parameter "Intensite" var: intensity  category: "car" ;
	//float le_cycle <- 0.04; 
	output {
		display tutoriel type: opengl {
			//species route refresh: false;
			species batiment;
			species Route aspect: base;
			species Place aspect: base;
			species Voiture aspect: icon;
			
			graphics "exit" refresh: false {
				draw sphere(5) at: dest2 color: #royalblue;
				/* 
				draw sphere(3) at: dest_1 color: #red;	
				draw sphere(3) at: dest_2 color: #red;	
				draw sphere(3) at: dest_3 color: #red;	
				draw sphere(3) at: dest_4 color: #red;
				
				draw sphere(3) at: init_1 color: #blue;	
				draw sphere(3) at: init_2 color: #blue;	
				draw sphere(3) at: init_3 color: #blue;	
				draw sphere(3) at: init_4 color: #blue;	*/
			}
		}
	}
}