CFLAGS := -ggdb -static -fno-stack-protector -z execstack



all: client server


client: client.c
	sudo gcc $(CFLAGS) -Wall client.c -o client
	sudo chmod 4755 client	

server: server.c
	sudo gcc $(CFLAGS) -Wall -pthread server.c -o server
	sudo chmod 4755 server

clean:
	rm -r -f *~ client server
