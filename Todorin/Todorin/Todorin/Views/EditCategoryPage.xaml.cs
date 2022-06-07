using Todorin.Models;
using Todorin.ViewModels;

namespace Todorin.Views
{
    public partial class EditCategoryPage
    {
        private readonly EditCategoryViewModel _editCategoryViewModel = new EditCategoryViewModel();

        public EditCategoryPage(Category category)
        {
            _editCategoryViewModel.Category = category;
            BindingContext = _editCategoryViewModel;
            InitializeComponent();
        }
    }
}