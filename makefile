CC = g++

CFLAGS= -O3 -g -std=c++17 -Wall  -w   -fopenmp -flto
CFLAGS_DELTA= -Ofast -std=c++17 -Wall -w 	
LDFLAGS = -LTurboPFor-Integer-Compression -l:libic.a -pthread -flto -lpthread -lz -fopenmp

PREXEC = turboPFor_compile
EXEC = k2r_index k2r_query test_colors
OBJ = utils.o index_color.o Decycling.o color.o test_colors.o
OBJ_INDEX = k2r_index.o utils.o index_color.o color.o Decycling.o TurboPFor-Integer-Compression/libic.a
OBJ_QUERY = k2r_query.o utils.o index_color.o color.o Decycling.o TurboPFor-Integer-Compression/libic.a
OBJ_TEST_COLOR = color.o test_colors.o

all :  $(EXEC)

TurboPFor-Integer-Compression/libic.a:
	make -C TurboPFor-Integer-Compression/

k2r_index : $(OBJ_INDEX)
	$(CC) -o k2r_index $^ $(LDFLAGS)

k2r_query : $(OBJ_QUERY)
	$(CC) -o k2r_query $^ $(LDFLAGS)

k2r_index.o: sources/k2r_index.cpp headers/MinimizerLister.h
	$(CC) -o $@ -c $< $(CFLAGS)

k2r_query.o: sources/k2r_query.cpp
	$(CC) -o $@ -c $< $(CFLAGS)

utils.o: sources/utils.cpp headers/utils.h
	$(CC) -o $@ -c $< $(CFLAGS)

index_color.o: sources/index_color.cpp headers/index_color.h
	$(CC) -o $@ -c $< $(CFLAGS)

Decycling.o: sources/Decycling.cpp headers/Decycling.h
	$(CC) -o $@ -c $< $(CFLAGS)

color.o: sources/color.cpp headers/color.h
	$(CC) -o $@ -c $< $(CFLAGS)

test_colors : $(OBJ_TEST_COLOR)
	$(CC) -o test_colors $^ $(LDFLAGS)

test_colors.o: tests/test_colors.cpp
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -rf $(EXEC) $(OBJ) $(OBJ_INDEX) $(OBJ_QUERY)*.dat .snakemake .vscode log/memory_res/ log/reads_res/

rebuild: clean $(EXEC)

SEQ_TO_QUERY = "seq2.fasta"

test:
	./k2r_index -r example/reads/reads.fasta -b example/output/output_binary -s 26 --min-ab 1
	./k2r_query -s example/sequences/$(SEQ_TO_QUERY) -o example/output/query_output -b example/output/output_binary -r 1
	sh check.sh example/reads/reads.fasta example/sequences/$(SEQ_TO_QUERY) example/output/query_output_$(SEQ_TO_QUERY)