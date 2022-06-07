using System.Collections.Generic;
using System.Collections.ObjectModel;
using Todorin.Models;
using Todorin.ViewModels;
using Xamarin.Forms.Xaml;

namespace Todorin.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class EditTaskPage
    {
        private readonly EditTaskViewModel _editTaskViewModel = new EditTaskViewModel();
        public EditTaskPage(Task task, ObservableCollection<Category> categories, List<Priority> priorities)
        {
            _editTaskViewModel.Task = task;
            _editTaskViewModel.Categories = new List<Category>(categories);
            _editTaskViewModel.Priorities = priorities;
            BindingContext = _editTaskViewModel;
            
            InitializeComponent();

            for (var i = 0; i < _editTaskViewModel.Categories.Count; i++)
            {
                if (task.TodoCategoryId != _editTaskViewModel.Categories[i].Id) continue;
                _editTaskViewModel.SelectedCategory = _editTaskViewModel.Categories[i];
                CategoryPicker.SelectedIndex = i;
            }
            
            for (var i = 0; i < _editTaskViewModel.Priorities.Count; i++)
            {
                if (task.TodoPriorityId != _editTaskViewModel.Priorities[i].Id) continue;
                _editTaskViewModel.SelectedPriority = _editTaskViewModel.Priorities[i];
                PriorityPicker.SelectedIndex = i;
            }
        }
    }
}