# Modelos MiniZinc para validación del TMLPA

Esta carpeta contiene los modelos de programación con restricciones desarrollados para validar la calidad de las soluciones obtenidas por las metaheurísticas COA y PSO.

## Archivos

| Archivo | Instancia | Tamaño |
|---|---|---|
| `small.mzn` | Small | 5 clientes × 3 hubs |
| `medium.mzn` | Medium | 50 clientes × 10 hubs |

**Nota:** No se incluye un modelo para la instancia **Big** (100 clientes × 20 hubs). La instancia Medium ya excedió el tiempo razonable de ejecución del solver exacto (ver más abajo), por lo que ejecutar Big resultaría inviable.

## Cómo ejecutar los modelos

Los modelos están preparados para ejecutarse en el **MiniZinc Playground**, el entorno web oficial de MiniZinc. No se requiere instalación local.

### Paso a paso

1. Abrir [https://play.minizinc.dev/](https://play.minizinc.dev/) en cualquier navegador moderno.
2. Abrir el archivo `.mzn` deseado en un editor de texto (por ejemplo, Visual Studio Code o el Bloc de notas).
3. Seleccionar **todo el contenido** del archivo (Ctrl+A) y copiarlo (Ctrl+C).
4. Pegarlo en el editor del Playground (Ctrl+V), reemplazando cualquier contenido previo.
5. Hacer clic en el botón **Run** (esquina superior).
6. La solución óptima aparecerá en el panel de salida.

## Resultados esperados

### Instancia Small (`small.mzn`)

- **Tiempo de ejecución:** ~211 ms
- **Función objetivo óptima:** **76.9**
- **Hubs habilitados:** `y = [1, 0, 1]`
- **Asignación de clientes:** `x = [1, 1, 3, 3, 3]`
- **Desglose:** costo de instalación = 43.2, costo de caminata = 33.7

Este óptimo coincide con el mejor valor alcanzado por COA y PSO en las 40 corridas, lo que valida la corrección de ambas implementaciones metaheurísticas.

### Instancia Medium (`medium.mzn`)

- **Tiempo de ejecución:** detenido manualmente tras ~40 minutos.
- **Resultado:** el solver **no entregó una solución óptima garantizada** dentro de ese tiempo.
- **Interpretación:** esta evidencia confirma empíricamente la naturaleza NP-difícil del TMLPA y justifica el uso de metaheurísticas (COA y PSO) en lugar de métodos exactos para instancias de tamaño no trivial.

## Notas adicionales

- El solver utilizado es el que el Playground asigna por defecto (Gecode o Chuffed según disponibilidad). No se requiere configuración manual.
- Los modelos están escritos en MiniZinc estándar sin extensiones específicas, por lo que también pueden ejecutarse en cualquier instalación local de MiniZinc.
