
import UIKit

class AgregarTareaViewController: UITableViewController {
    
    @IBOutlet weak var campoTitulo: UITextField!
    @IBOutlet weak var botonCompletada: UIButton!
    @IBOutlet weak var etiquetaFechaLimite: UILabel!
    @IBOutlet weak var seleccionadorFechaLimite: UIDatePicker!
    @IBOutlet weak var campoNotas: UITextView!
    
    @IBOutlet weak var botonGuardar: UIBarButtonItem!
    
    var isOcultoSeleccionadorFecha = true
    
    var tarea: Tarea?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tarea = tarea {
            navigationItem.title = "Tarea"
            campoTitulo.text = tarea.titulo
            botonCompletada.isSelected = tarea.completada
            seleccionadorFechaLimite.date = tarea.fechaLimite
            campoNotas.text = tarea.notas
        } else {
            seleccionadorFechaLimite.date = Date().addingTimeInterval(24*60*60)
        }
        
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let alturaCeldaNormal = CGFloat(44)
        let alturaCeldaGrande = CGFloat(200)
        
        switch(indexPath) {
        case [1,0]: // Celda de Fecha Límite
            return isOcultoSeleccionadorFecha ? alturaCeldaNormal : alturaCeldaGrande
            
        case [2,0]: // Celda de Notas
            return alturaCeldaGrande
            
        default: return alturaCeldaNormal
        }
    }
    
    // Responder al toque del usuario
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isOcultoSeleccionadorFecha = !isOcultoSeleccionadorFecha
            etiquetaFechaLimite.textColor = isOcultoSeleccionadorFecha ? .black : tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "guardarDeshacer" else { return }
        let titulo = campoTitulo.text!
        let completada = botonCompletada.isSelected
        let fechaLimite = seleccionadorFechaLimite.date
        let notas = campoNotas.text
        tarea = Tarea(titulo: titulo, completada: completada, fechaLimite: fechaLimite, notas: notas ?? <#default value#>)
    }
    
    
    
    func actualizarEstadoBotonGuardar() {
        let texto = campoTitulo.text ?? ""
        botonGuardar.isEnabled = !texto.isEmpty
    }
    
    
    
    
    
    // Este teclado se llamará cuando haya algún cambio en el campo de texto
    @IBAction func edicionTextoCambiada(_ sender: UITextField) {
        actualizarEstadoBotonGuardar()
    }
    
    // Esta acción se llamará cuando presionemos retorno en el teclado
    @IBAction func retornoPresionado(_ sender: UITextField) {
        campoTitulo.resignFirstResponder()
    }
    
    @IBAction func botonCompletadaPresionado(_ sender: UIButton) {
        botonCompletada.isSelected = !botonCompletada.isSelected
    }
}
