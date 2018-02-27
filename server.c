#include <stddef.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <errno.h>
#include <stdio.h>
#include <pthread.h>




#include "protocol.h"

typedef struct {
	int self;
	int other;
	char *name;
} relay;

int verifyme(int s, char **username) {
	char buff[100]; //THIS IS A VULNERABILITY
	recv(s, buff, 1602, 0);

	int uname_length = strlen(buff);
	*username = (char *) malloc(sizeof(char) * uname_length);
	strcpy(*username, buff);
	
	
	char password[800];
	strcpy(password, (buff + uname_length + 1));

	if (!strcmp(*username, "user1")) {
		return !strcmp(password, "password1");
	}
	else if (!strcmp(*username, "user2")) {
		return !strcmp(password, "password2");
	}

	return 0;
}
			


void *run_client(void *arg) {
	relay *both = (relay *) arg;

	
	char outbuf[1602];
	char inbuf[801];
	strcpy(outbuf,both->name);
	while (1) {
		recv(both->self, inbuf, 801, 0);
		strcpy(outbuf + strlen(both->name) + 1, inbuf);
		send(both->other, outbuf, strlen(outbuf) + 1 +strlen(inbuf)+ 1, 0);
	}


	return NULL;

}

	
int main(int argc, char *argv[]) {

  printf("%p\ntest\n", &main);
  
	int s; //accepting client connections
	struct sockaddr_in server; //our setup
	struct sockaddr_in client_connection; //to accept a new client
	char *ret = "no";
	char *ok = "ok";
       
	
	


	if (argc != 2) {
		printf("proper usage is ./server <port>");
		return 1;
	}


	server.sin_family = AF_INET;
	server.sin_port = htons(atoi(argv[1]));
	inet_pton(AF_INET, IP_ADDR, &server.sin_addr);


	if ( (s = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
		perror("Problem resolving socket");
		return 1;
	}

	if (bind(s, (struct sockaddr *) &server, sizeof(server)) == -1) {
		perror("Couldn't bind to socket.  Maybe something is using it.");
		return 1;
	}


	//listen to the socket

	listen(s, 2); //up to 10 people can connect and chat at a time.

        int clients[2];
	char *names[2];
	for (int i = 0; i < 2; i++ ) {

		socklen_t expected_size = sizeof(client_connection);

		int client = accept(s, (struct sockaddr *) &client_connection, &expected_size);

	

		if (!verifyme(client, &names[i])) {
			send(client, ret, 2, 0);
			return 1;
		}
		else {
			send(client, ok, 2, 0);

		}
			
			
		clients[i] = client;

		

	}

	relay client_args[2];
	client_args[0].self = clients[0];
	client_args[1].self = clients[1];
	client_args[0].other = clients[1];
	client_args[1].other = clients[0];
	client_args[0].name = names[0];
	client_args[1].name = names[1];

	pthread_t client_threads[2];
	pthread_create(&client_threads[0], NULL, run_client, &client_args[0]);
	pthread_create(&client_threads[1], NULL, run_client, &client_args[1]);

	//wait for the clients to close
	pthread_join(client_threads[0], NULL);
	pthread_join(client_threads[1], NULL);
	

	return 0;
	
}
