import UIKit

class RecipeIngredientsController: UITableViewController {

  @IBOutlet weak var bannerView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!

  var selectedIngredientPaths = [IndexPath]()
  var recipe: Recipe?
  var originalHeaderHeight: CGFloat = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    originalHeaderHeight = headerHeightConstraint.constant

    titleLabel.text = recipe?.name
    if let url = recipe?.imageURL {
      bannerView.sd_setImage(with: url)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  // MARK: UITableViewDataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipe?.ingredients.count ?? 0
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientsCell", for: indexPath) as UITableViewCell

    if let item = recipe?.ingredients[(indexPath as NSIndexPath).row] {
      let text = "\(item.quantity) \(item.name)"

		var attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17)];

      // lighten and strikethrough the ingredient if we have added it
      if selectedIngredientPaths.contains(indexPath) {
		attributes[NSAttributedStringKey.foregroundColor] = UIColor.lightGray
		attributes[NSAttributedStringKey.strikethroughStyle] = NSUnderlineStyle.styleSingle.rawValue
      } else {
		attributes[NSAttributedStringKey.foregroundColor] = UIColor.black
      }

      cell.textLabel?.attributedText = NSAttributedString(string: text, attributes: attributes)
    }

    return cell
  }

  // MARK: UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let index = selectedIngredientPaths.index(of: indexPath) {
      selectedIngredientPaths.remove(at: index)
    } else {
      selectedIngredientPaths.append(indexPath)
    }
    tableView.reloadData()
  }

  // MARK: UIScrollViewDelegate

  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    headerHeightConstraint.constant = originalHeaderHeight - scrollView.contentOffset.y
  }

}
