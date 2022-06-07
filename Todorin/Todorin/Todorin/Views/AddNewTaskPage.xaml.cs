using System.Collections.Generic;
using System.Collections.ObjectModel;
using Todorin.Models;
using Todorin.ViewModels;
using Xamarin.Forms.Xaml;

namespace Todorin.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class AddNewTaskPage
    {
        private readonly AddNewTaskViewModel _addNewTaskViewModel = new AddNewTaskViewModel();

        public AddNewTaskPage(Category category, ObservableCollection<Category> categories, List<Priority> priorities)
        {
            _addNewTaskViewModel.Categories = new List<Category>(categories);
            _addNewTaskViewModel.Priorities = priorities;
            BindingContext = _addNewTaskViewModel;
            
            InitializeComponent();
            
            for (var i = 0; i < _addNewTaskViewModel.Categories.Count; i++)
            {
                if (category.Id != _addNewTaskViewModel.Categories[i].Id) continue;
                _addNewTaskViewModel.SelectedCategory = _addNewTaskViewModel.Categories[i];
                CategoryPicker.SelectedIndex = i;
            }

            _addNewTaskViewModel.SelectedPriority = _addNewTaskViewModel.Priorities[0];
            PriorityPicker.SelectedIndex = 0;
        }
    }
}