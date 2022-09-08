# JSON encoder and decoder

Algunas notas para el uso del **script**: 

* main.m es el archivo principal, el unico que se deberia abrir. Dentro de el, el usuario solo deberia cambiar la seccion *Data manipulation*, en las lineas 30 a 41. 

* Los archivos modificados se almacenan en la maquina local desde la que se ejecuta main.m en formato JSON en la carpeta *files*.

* La carpeta *templates* contiene los archivos originales y vacios. Esta carpeta actua como copia de seguridad y tanto ella como los archivos que contienen deberian permanecer inmutables.

* En *lib* se encuentran las dos funciones principales, una de codificacion y otra de decodificacion, que se pueden usar en otros contextos. 