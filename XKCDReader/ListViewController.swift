import UIKit
import AlamofireImage

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var comics: [Comic] = []
    
    var lastNum : Int!
    var localLastNum: Int!
    
    let cellIdentifier = "kCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLastComic()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func loadLastComic() {
        Comic.loadLast{ lastComic in
            self.lastNum = lastComic!.num
            self.localLastNum = lastComic!.num
            self.comics.append(lastComic!)
            self.tableView.reloadData()
        }
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comics.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ComicTableViewCell
        let product = comics[indexPath.row]

        if let url = URL(string: product.image) {
            cell?.iconImageView?.af_setImage(withURL: url)
        }
        
        cell?.titleLabel?.text = product.title
        cell?.numberLabel?.text = "\(product.num)";

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        guard let comicViewController = self.storyboard?.instantiateViewController(withIdentifier: "ComicViewController") as? ComicViewController else {
            return
        }

        let comic = comics[indexPath.row]

        comicViewController.comic = comic

        self.navigationController?.pushViewController(comicViewController, animated: true)
    }
    
    // add next comic from website
    @IBAction func addButtonPressed(_sender: Any){
        localLastNum = localLastNum - 1
        Comic.load(num: localLastNum){ comic in
            self.comics.append(comic!)
            self.tableView.reloadData()
        }
    }
    
    // delete comic with swipe
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.comics.remove(at: index.row)
            self.tableView.reloadData()
        }
        delete.backgroundColor = .red
        
        return [delete]
    }
}
