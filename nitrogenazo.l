%{
#include <stdio.h>
#include <string.h>
#include <curl/curl.h>

int nc, np, nl;

int avisos = 0;

int nitrogeno, nitrogeno_max = 0, nitrogeno_perm = 200;

int parametro_c = 0;

int suma_media = 0, media, validos = 0;

char estacion[32];
char marcador = ' ';

size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream);
void limpiar_variables();

%}

letra		[a-zA-Z]
digito		[0-9]

parametro   {digito}{2}
medicion 	{digito}{5}
correcta 	V

%s			nb

%%

{parametro}	{ 
				// Cutre, cutre pero funciona
				// Como hay varios datos que tienen dos cifras nos aseguramos
				// de que comprobemos solo el primero, el que nos interesa
				if (!strcmp("08",yytext) && parametro_c == 0)
					BEGIN(nb);
				parametro_c++;
			}

<nb>{medicion}	{
					nitrogeno = atoi(yytext);
					suma_media += nitrogeno;

					if (nitrogeno > nitrogeno_max) 
						nitrogeno_max = nitrogeno;
				}

<nb>{correcta}	{ validos++; }

<nb>\n 		{
				if (nitrogeno_max >= nitrogeno_perm) {
					avisos++;
					marcador = '*';
				}

				media = suma_media / validos;

				printf("%c\t%i\t\t%i\t\t%s\n", marcador, nitrogeno_max, media, estacion);

				BEGIN(0);

				limpiar_variables();
			}

\n 			{ parametro_c = 0; }

.|\n		{ }

28,079,004	{ strcpy(estacion, "Plaza de España"); }
28,079,035	{ strcpy(estacion, "Plaza del Carmen"); }
28,079,039	{ strcpy(estacion, "Barrio del Pilar");  }
28,079,008	{ strcpy(estacion, "Escuelas Aguirre"); }
28,079,038	{ strcpy(estacion, "Cuatro Caminos"); }
28,079,011	{ strcpy(estacion, "Avenida Ramón y Cajal"); }
28,079,040	{ strcpy(estacion, "Vallecas"); }
28,079,016	{ strcpy(estacion, "Arturo Soria"); }
28,079,017	{ strcpy(estacion, "Villaverde Alto"); }
28,079,018	{ strcpy(estacion, "Calle Farolillo"); }
28,079,036	{ strcpy(estacion, "Moratalaz"); }
28,079,024	{ strcpy(estacion, "Casa de Campo"); }
28,079,027	{ strcpy(estacion, "Barajas"); }
28,079,047	{ strcpy(estacion, "Méndez Álvaro"); }
28,079,048	{ strcpy(estacion, "Pº. Castellana"); }
28,079,049	{ strcpy(estacion, "Retiro"); }
28,079,050	{ strcpy(estacion, "Plaza Castilla"); }
28,079,054	{ strcpy(estacion, "Ensanche Vallecas"); }
28,079,055	{ strcpy(estacion, "Urb. Embajada (Barajas)"); }
28,079,056	{ strcpy(estacion, "Plaza Fernández Ladreda"); }
28,079,057	{ strcpy(estacion, "Sanchinarro"); }
28,079,058	{ strcpy(estacion, "El Pardo"); }
28,079,059	{ strcpy(estacion, "Parque Juan Carlos I"); }
28,079,060	{ strcpy(estacion, "Tres Olivos"); }

%%

int main(int argc, char const *argv[])
{
	// Primero descargamos el archivo con curl
	// https://stackoverflow.com/questions/1636333/download-file-using-libcurl-in-c-c
	CURL *curl;
    FILE *fp;
    CURLcode res;
    char *url = "http://www.mambiente.munimadrid.es/opendata/horario.txt";
    char outfilename[FILENAME_MAX] = "horario.txt";
    curl = curl_easy_init();

    if (curl) {
    	printf("%s\n", "Descargando el archivo horario de datos...");
        fp = fopen(outfilename,"wb");
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_data);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, fp);
        res = curl_easy_perform(curl);
        /* always cleanup */
        curl_easy_cleanup(curl);
        fclose(fp);
    }

    // Lo abrimos una vez descargado (si es posible)
    printf("%s\n", "Archivo descargado. Abriendo archivo...");
	yyin = fopen (outfilename, "rt");

	if (yyin == NULL)
	{
		printf("El fichero no se ha podido abrir\n");
		exit(-1);
	}

	printf("%s\n", "Comienza el análisis:");
	printf("AVISO\tMáximo µg/m^3\tMedia µg/m^3\tESTACIÓN\n");
	printf("==============================================================\n");

	// Ejecutamos Lex
	yylex();

	if (avisos == 1)
	{
		printf("%i estación ha superado el máximo permitido de dióxido de nitrógeno hoy\n", avisos);
	} else {
		printf("%i estaciones han superado el máximo permitido de dióxido de nitrógeno hoy\n", avisos);
	}
	
	return 0;
}

// Función auxiliar para la descarga con curl
size_t write_data(void *ptr, size_t size, size_t nmemb, FILE *stream) {
    size_t written = fwrite(ptr, size, nmemb, stream);
    return written;
}

void limpiar_variables() {
	marcador = ' ';
	nitrogeno_max = 0;
	validos = 0;
	parametro_c = 0;
	suma_media = 0;
}