import UIKit

@objc protocol DelegadoCeldaTarea: class {
    func marcaDeVerificaciónTocada(emisor: CeldaTarea)
}

class CeldaTarea: UITableViewCell {
    @IBOutlet weak var botonCompletada: UIButton!
    @IBOutlet weak var tituloLabel: UILabel!
    
    var delegado: DelegadoCeldaTarea?
    
    @IBAction func botonCompletadaPresionado() {
        delegado?.marcaDeVerificaciónTocada(emisor: self)
    }

}
