# laboratorio12-tdlc

Ejercicios del laboratorio 12 resueltos en Haskell, utilizando funciones lambda.

## Requisitos

Se necesita GHC. En Fedora se instala con:

    sudo dnf install ghc

## Ejecución

Cada ejercicio se encuentra en su propio archivo y se ejecuta con `runghc`, por ejemplo:

    runghc Ejercicio1.hs

En todos los programas, si se presiona Enter sin escribir datos se utiliza el ejemplo del enunciado.

## Ejercicio 1

Ordena una lista de diccionarios según una llave. Cada diccionario se ingresa en una línea con pares `clave=valor` separados por comas:

    make=Nokia, model=216, color=Black

Una línea vacía termina el ingreso. Luego el programa pide la llave por la cual ordenar (por ejemplo `model`) y muestra la lista ordenada. Se puede ordenar por varias llaves seguidas hasta dejar la línea vacía. Si la llave no existe en ningún diccionario se muestra un aviso.

Los valores enteros se comparan como números y los demás como texto. Los diccionarios que no tienen la llave indicada quedan al inicio.

## Ejercicio 2

Calcula la potencia n-ésima de cada elemento de una lista de enteros. Primero se ingresa la lista, con los números separados por espacios o comas (también se aceptan corchetes, como `[1, 2, 3]`), y después el valor de n, que debe ser un entero positivo. Si alguno de los datos no es válido, el programa lo vuelve a pedir.

Con Enter se usan la lista `[1, 2, ..., 10]` y `n = 3` del enunciado. Se trabaja con `Integer`, por lo que no hay desbordamiento con potencias grandes.
