#nullable enable
using System;
using System.Linq;
using Todorin.Helpers;
using Todorin.Models;
using Todorin.Services;
using Todorin.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace Todorin.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class TasksPage
    {
        private readonly TasksViewModel _tasksViewModel = new TasksViewModel();

        public TasksPage(Category? category)
        {
            if (category != null)
            {
                _tasksViewModel.Category = category;
            }
            else
            {
                _tasksViewModel.Category = new Category
                {
                    CategoryName = "All Todo's"
                };
            }

            BindingContext = _tasksViewModel;
            InitializeComponent();
            SortReset.BackgroundColor = Color.Transparent;
            SetSortButtonsColors();
            
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            if (Application.Current.MainPage is NavigationPage navigationPage)
                navigationPage.SetAppThemeColor(
                    NavigationPage
                        .BarBackgroundColorProperty, Constants.CLightPrimaryColor, Constants.CDarkPrimaryColor);
            SetSortButtonsColors();
            _tasksViewModel.GetTasks();
        }

        private void SetSortButtonsColors()
        {
            switch (Settings.SortingMode)
            {
                case 0:
                    SortName.BackgroundColor = Color.Transparent;
                    SortImportant.BackgroundColor = Color.Transparent;
                    SortNormal.BackgroundColor = Color.Transparent;
                    SortDate.BackgroundColor = Color.Transparent;
                    break;
                case 1:
                    SortName.BackgroundColor = Color.Crimson;
                    SortImportant.BackgroundColor = Color.Transparent;
                    SortNormal.BackgroundColor = Color.Transparent;
                    SortDate.BackgroundColor = Color.Transparent;
                    break;
                case 2:
                    SortName.BackgroundColor = Color.Transparent;
                    SortImportant.BackgroundColor = Color.Crimson;
                    SortNormal.BackgroundColor = Color.Transparent;
                    SortDate.BackgroundColor = Color.Transparent;
                    break;
                case 3:
                    SortName.BackgroundColor = Color.Transparent;
                    SortImportant.BackgroundColor = Color.Transparent;
                    SortNormal.BackgroundColor = Color.Crimson;
                    SortDate.BackgroundColor = Color.Transparent;
                    break;
                case 4:
                    SortName.BackgroundColor = Color.Transparent;
                    SortImportant.BackgroundColor = Color.Transparent;
                    SortNormal.BackgroundColor = Color.Transparent;
                    SortDate.BackgroundColor = Color.Crimson;
                    break;
            }
        }

        private async void Star_OnClicked(object sender, EventArgs e)
        {
            var ib = (ImageButton) sender;
            foreach (var task in _tasksViewModel.Tasks)
            {
                if (task.Id != ib.CommandParameter.ToString()) continue;
                var _task = task;

                if (_task.TodoPriorityId == _tasksViewModel.Priorities[0].Id)
                {
                    _task.TodoPriorityId = _tasksViewModel.Priorities[1].Id;
                    _task.PriorityName = _tasksViewModel.Priorities[1].PriorityName;
                }
                else
                {
                    _task.TodoPriorityId = _tasksViewModel.Priorities[0].Id;
                    _task.PriorityName = _tasksViewModel.Priorities[0].PriorityName;
                }
                
                var response = await ApiTasks.PutTaskAsync(_task, Settings.JwtToken);

                if (!response.IsSuccessStatusCode) continue;
                task.TodoPriorityId = _task.TodoPriorityId;
                task.PriorityName = _task.PriorityName;
                task.PriorityIcon = ImageSource.FromFile(task.PriorityName == "Important"
                    ? "star_yellow.png"
                    : "star_outlined_black.png");
            }
        }

        private async void Done_OnClicked(object sender, EventArgs e)
        {
            var mi = (MenuItem) sender;
            foreach (var task in _tasksViewModel.Tasks)
            {
                if (task.Id != mi.CommandParameter.ToString()) continue;
                var _task = task;
                _task.IsCompleted = !_task.IsCompleted;
                
                var response = await ApiTasks.PutTaskAsync(_task, Settings.JwtToken);

                if (!response.IsSuccessStatusCode) continue;
                task.IsCompleted = _task.IsCompleted;
                task.PriorityName = _task.PriorityName;
                task.TextDecorations = task.IsCompleted ? TextDecorations.Strikethrough : TextDecorations.None;
            }
        }

        private async void Delete_OnClicked(object sender, EventArgs e)
        {
            var mi = (MenuItem) sender;
            var response = await ApiTasks.DeleteTaskAsync(mi.CommandParameter.ToString(), Settings.JwtToken);

            if (!response.IsSuccessStatusCode) return;
            _tasksViewModel.Tasks
                .Remove(_tasksViewModel.Tasks
                    .Single(task => task.Id == mi.CommandParameter.ToString())
                );
        }

        private async void GoToAddNewTask_OnClicked(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new AddNewTaskPage(_tasksViewModel.Category, _tasksViewModel.Categories, _tasksViewModel.Priorities));
        }

        private async void ListView_OnItemTapped(object sender, ItemTappedEventArgs e)
        {
            var task = e.Item as Task;
            await Navigation.PushAsync(
                new EditTaskPage(task, _tasksViewModel.Categories, _tasksViewModel.Priorities));
        }

        private async void Alarm_OnClicked(object sender, EventArgs e)
        {
            var ib = (ImageButton) sender;
            foreach (var task in _tasksViewModel.Tasks)
            {
                if (task.Id != ib.CommandParameter.ToString()) continue;
                await Navigation.PushAsync(new SetDueDatePage(task));
            }
        }

        private void SortReset_OnClicked(object sender, EventArgs e)
        {
            Settings.SortingMode = 0;
            SetSortButtonsColors();
            _tasksViewModel.SortTasks();
        }

        private void SortName_OnClicked(object sender, EventArgs e)
        {
            Settings.SortingMode = 1;
            SetSortButtonsColors();
            _tasksViewModel.SortTasks();
        }

        private void SortImportant_OnClicked(object sender, EventArgs e)
        {
            Settings.SortingMode = 2;
            SetSortButtonsColors();
            _tasksViewModel.SortTasks();
        }

        private void SortNormal_OnClicked(object sender, EventArgs e)
        {
            Settings.SortingMode = 3;
            SetSortButtonsColors();
            _tasksViewModel.SortTasks();
        }

        private void SortDate_OnClicked(object sender, EventArgs e)
        {
            Settings.SortingMode = 4;
            SetSortButtonsColors();
            _tasksViewModel.SortTasks();
        }
    }
}