# Nitrogenazo

Nitrogenazo es una aplicación escrita en C utilizando [Flex](https://github.com/westes/flex), una herramienta que genera programas que pueden reconocer patrones en texto.

Se ha desarrollado para la asignatura Modelos de Computación del Doble Grado en Ingeniería Informática y Matemáticas de la Universidad de Granada.

La aplicación en sí es muy sencilla. Al ejecutarse descarga los [datos horarios](http://www.mambiente.munimadrid.es/opendata/horario.txt) de las estaciones de medición de calidad del aire de la ciudad de Madrid. Posteriormente los escanea y busca los datos relacionados con el *dióxido de nitrógeno*.

El protocolo de medidas a adoptar durante episodios de alta contaminación de dióxido de nitrógeno especifia que se activa el aviso por alta contaminación cuando se superan los 200µg/m^3 durante dos horas en al menos dos estaciones de una misma zona. Sin embargo, para facilitar el desarrollo, esta aplicación supone que se activa el aviso en cuanto se supera dicho límite **durante una hora** en una **única** estación.

## Compilación

Simplemente ejecuta `make`:

```
$> make
flex -o nitrogenazo.c nitrogenazo.l
gcc -o nitrogenazo nitrogenazo.c -ll -lcurl
```

## Uso

Al ejecutar la aplicación se descargan los datos y se muestran por pantalla:

```
$> ./nitrogenazo
Descargando el archivo horario de datos...
Archivo descargado. Abriendo archivo...
Comienza el análisis:
AVISO	Máximo µg/m^3	Media µg/m^3	ESTACIÓN
==============================================================
*        230			   20			    Plaza de España
 		83				46				Escuelas Aguirre
 		53				25				Avenida Ramón y Cajal
 		38				19				Arturo Soria
 		37				16				Villaverde Alto
 		27				11				Calle Farolillo
 		8				  2				Casa de Campo
 		17				10				Barajas
 		51				31				Plaza del Carmen
 		48				23				Moratalaz
 		35				19				Cuatro Caminos
 		36				18				Barrio del Pilar
 		34				18				Vallecas
 		33				15				Méndez Álvaro
 		47				27				Pº. Castellana
 		36				16				Retiro
* 	   209			   24			    Plaza Castilla
 		23				10				Ensanche Vallecas
 		19				10				Urb. Embajada (Barajas)
 		39				20				Plaza Fernández Ladreda
 		22				11				Sanchinarro
 		5				  2				El Pardo
 		17				 8				Parque Juan Carlos I
 		20				11				Tres Olivos
2 estaciones han superado el máximo permitido de dióxido de nitrógeno hoy
```
