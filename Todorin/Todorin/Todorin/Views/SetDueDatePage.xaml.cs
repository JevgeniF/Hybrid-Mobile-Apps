using System;
using Todorin.Models;
using Todorin.ViewModels;
using Xamarin.Forms.Xaml;

namespace Todorin.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SetDueDatePage
    {
        private readonly SetDueDateViewModel _setDueDateViewModel = new SetDueDateViewModel();
        public SetDueDatePage(Task task)
        {
            _setDueDateViewModel.CTask = task;
            BindingContext = _setDueDateViewModel;
            InitializeComponent();
            if (task.DueDt == null) return;
            var dateTime = DateTime.Parse(task.DueDt).ToLocalTime();
            _setDueDateViewModel.SelectedDate = dateTime;
            _setDueDateViewModel.SelectedTime = dateTime.TimeOfDay;
        }
    }
}