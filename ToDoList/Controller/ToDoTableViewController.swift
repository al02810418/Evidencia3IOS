import UIKit

class Tarea: Codable {
    var titulo: String
    var completada: Bool
    var fechaLimite: Date
    var notas: String

    init(titulo: String, completada: Bool, fechaLimite: Date, notas: String) {
        self.titulo = titulo
        self.completada = completada
        self.fechaLimite = fechaLimite
        self.notas = notas
    }
    
    static func cargarTareas() -> [Tarea]? {
        if let data = UserDefaults.standard.data(forKey: "tareas"),
           let tareas = try? JSONDecoder().decode([Tarea].self, from: data) {
            return tareas
        }
        return nil
    }
    
    static func guardarTareas(_ tareas: [Tarea]) {
        if let data = try? JSONEncoder().encode(tareas) {
            UserDefaults.standard.set(data, forKey: "tareas")
        }
    }
    
    static func cargarTareasEjemplo() -> [Tarea] {
        // Aquí puedes crear y devolver un conjunto de tareas de ejemplo
        let tarea1 = Tarea(titulo: "Completar informe", completada: false, fechaLimite: Date(), notas: "Este informe debe completarse antes del viernes.")
        let tarea2 = Tarea(titulo: "Ir al gimnasio", completada: false, fechaLimite: Date(), notas: "Ejercicio de cardio y levantamiento de pesas.")
        return [tarea1, tarea2]
    }
}

class ListaDeTareasViewController: UITableViewController, DelegadoCeldaTarea {

    var tareas = [Tarea]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Agregando el botón de Edición en el lado izquierdo del Controlador de Vista
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let guardarTareas = Tarea.cargarTareas(){
            tareas = guardarTareas
        } else {
            tareas =  Tarea.cargarTareasEjemplo()
        }
    }
    
    // Esto le dirá a la tabla cuántas filas habrá en una sección
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tareas.count
    }
    
    // Esto mostrará lo que va a estar en la celda para cada fila
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let celda = tableView.dequeueReusableCell(withIdentifier: "IdentificadorCeldaTarea") as? CeldaTarea else {
            fatalError("No se pudo hacer dequeue de una celda")
        }

        celda.delegado = self
        
        let tarea = tareas[indexPath.row]
        celda.tituloLabel?.text = tarea.titulo
        celda.botonCompletada.isSelected = tarea.completada
        return celda
    }
    
    // Esto permitirá la edición para cada fila
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Esto eliminará la fila
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Verificar que el botón de Eliminar haya activado la llamada al método
        if editingStyle == .delete {
            tareas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Tarea.guardarTareas(tareas)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarDetalles" {
            let controladorTarea = segue.destination as! AgregarTareaViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let tareaSeleccionada = tareas[indexPath.row]
            controladorTarea.tarea = tareaSeleccionada
        }
    }
    
    func marcaDeVerificaciónTocada(emisor: CeldaTarea) {
        if let indexPath = tableView.indexPath(for: emisor) {
            var tarea = tareas[indexPath.row]
            tarea.completada = !tarea.completada
            tareas[indexPath.row] = tarea
            tableView.reloadRows(at: [indexPath], with: .automatic)
            Tarea.guardarTareas(tareas)
        }
    }
    
    @IBAction func deshacerParaListaDeTareas(segue: UIStoryboardSegue) {
        guard segue.identifier == "guardarDeshacer" else { return }
        let controladorFuente = segue.source as! AgregarTareaViewController
        
        if let tarea = controladorFuente.tarea {
            if let indexPathSeleccionado = tableView.indexPathForSelectedRow { // si la celda ya está seleccionada no se creará un nuevo dato en su lugar se actualizará
                tareas[indexPathSeleccionado.row] = tarea
                tableView.reloadRows(at: [indexPathSeleccionado], with: .none)
            } else {
                let nuevoIndexPath = IndexPath(row: tareas.count, section: 0)
                tareas.append(tarea)
                tableView.insertRows(at: [nuevoIndexPath], with: .automatic)
            }
        }
        Tarea.guardarTareas(tareas)
    }
}
