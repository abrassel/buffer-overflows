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

#include "protocol.h"

#define true 1
#define false 0

typedef struct {
	char usr[801];
	char msg[801];
} chat_response;


/**
 * THIS IS VULNERABILITY TWO
 *
 */
static void get_response(int s, chat_response *target) {
	char incoming[100]; // oh no!  we can only hold 100 characters!
	recv(s, incoming, 1602, 0); //read in up to 1602 bytes from the incoming packet.  Hm.  That could be a problem.

	int uname_length = strlen(incoming);
	strcpy(target->usr, incoming);
	
	strcpy(target->msg, (incoming + uname_length + 1));
}

	

int main(int argc, char *argv[]) {
	int s; //hold socket
	int pid; //fork id
	char uname[801];
	char pwd[801];
	struct sockaddr_in connection;
	uint8_t uname_l;
	uint8_t pwd_l;
	char *authent_buf;

	uname[800] = '\0';
	pwd[800] = '\0';
	
	if (argc != 2) {
		printf("Proper usage is ./client <port>");
		return 1;
	}
	


	
	/**
	 *  SET UP SERVER CONNECTION HERE
	 */
	


	if (!(s = socket(AF_INET, SOCK_STREAM, 0))) {
		perror("Could not obtain a socket");
		return 1;
	}

	connection.sin_family = AF_INET;
	connection.sin_port = htons(atoi(argv[1]));
	inet_pton(AF_INET, IP_ADDR, &connection.sin_addr);
	
	if (connect(s, (struct sockaddr *) &connection, sizeof(connection)) == -1) {
		perror("Could not bind to port.  Is it in use?");
		return 1;
	}

	

	/**
	 * END SERVER SETUP
	 */



	/**
	 * BEGIN INITIALIZATION.
	 * 
	 * THIS IS VULNERABILITY 1
	 *
	 */

	printf("Please input your username: ");
	scanf("%800s", uname);

	char dummy[2];
	fgets(dummy, 2, stdin); //scrub first message
	printf("\nPlease input your password: ");
	fgets(pwd, 801, stdin); //read up to 800 characters
	int i;
	for (i = 1; pwd[i] != '\n'; i++);

	pwd[i] = '\0';


	uname_l = strlen(uname);
	pwd_l = i;


	if (pwd[0] == '\\' && pwd[1] == 'u') {
		FILE *pwd_file = fopen(pwd + 3, "r");
		
		pwd_l = fread(pwd, sizeof(char), 801, pwd_file);
		pwd_l -= 1;
	}

      
	/**
	 * CRAFT ACKNOWLEDGEMENT PACKET
	 *
	 *
	 */
	int len = sizeof(char) * (uname_l + pwd_l + 2);
	authent_buf = (char *) malloc(sizeof(char) * len); //user, pwd, unamelength

	strcpy(authent_buf , uname);
	memcpy(authent_buf + uname_l + 1, pwd, pwd_l+1);

	send(s, authent_buf, sizeof(char) * len, 0);


	/**
	 * GET ACKNOWLEDGMENT PACKET
	 *
	 *
	 */
	char authent[3];
	authent[2] = '\0';
	recv(s, authent, 2, 0); //get the "ok"

	if (strcmp(authent, "ok")) {
		printf("Access refused.\n");
		return 1;
	}


	if (!(pid = fork())) {
		//this is the child process
		//use this space for handling chat responses

		chat_response resp;
		while (true) {

			get_response(s, &resp);
			printf("%s: %s\n", resp.usr, resp.msg);

		}


	}

	else {
		char dummy[1];
		fgets(dummy, 1, stdin); //scrub first message
		while (true) {

			char msg[801];
			int msg_l;

		        fgets(msg, 801, stdin); //read up to 800 characters
			msg[strlen(msg)-1] = '\0'; 
			

			if (!strcmp(msg, "\\quit")) {
				printf("Ending connection.");
				break;
			}

			msg_l = strlen(msg);
			
			if (msg[0] == '\\' && msg[1] == 'u') {
				FILE *msg_file = fopen(msg + 3, "r");
		
				msg_l = fread(msg, sizeof(char), 801, msg_file);
				msg_l -= 1;
			}
      
			send(s, msg, sizeof(char) * (msg_l + 1), 0);

		}
	}

	kill(pid, SIGTERM); //kill fork
	
	return 1;

}
  
