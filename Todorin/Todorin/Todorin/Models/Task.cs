using System.ComponentModel;
using System.Runtime.CompilerServices;
using Xamarin.Forms;

namespace Todorin.Models
{
    public sealed class Task : INotifyPropertyChanged
    {
        public Task()
        {
            TaskSort = 0;
            IsCompleted = false;
            IsArchived = false;
        }
        public string Id { get; set; }

        private string _taskName;
        public string TaskName
        {
            get => _taskName;
            set
            {
                _taskName = value;
                OnPropertyChanged();
            }
        }

        private int TaskSort { get; set; }
        private string CreateDt { get; set; }
        private string _dueDt;
        public string DueDt
        {
            get => _dueDt;
            set
            {
                _dueDt = value;
                OnPropertyChanged();
            }
        }
        private bool _isCompleted;
        public bool IsCompleted
        {
            get => _isCompleted;
            set
            {
                _isCompleted = value;
                OnPropertyChanged();
            }
        }

        private bool IsArchived { get; set; }
        private string _todoCategoryId;
        public string TodoCategoryId
        {
            get => _todoCategoryId;
            set
            {
                _todoCategoryId = value;
                OnPropertyChanged();
            }
        }
        private string _todoPriorityId;
        public string TodoPriorityId
        {
            get => _todoPriorityId;
            set
            {
                _todoPriorityId = value;
                OnPropertyChanged();
            }
        }

        private string SyncDt { get; set; }
        
        //------- additional properties ------
        private string _categoryName;
        public string CategoryName
        {
            get => _categoryName;
            set
            {
                _categoryName = value;
                OnPropertyChanged();
            }
        }
        private string _priorityName;
        public string PriorityName
        {
            get => _priorityName;
            set
            {
                _priorityName = value;
                OnPropertyChanged();
            }
        }
        private ImageSource _priorityIcon;
        public ImageSource PriorityIcon
        {
            get => _priorityIcon;
            set
            {
                _priorityIcon = value;
                OnPropertyChanged();
            }
        }
        private TextDecorations _textDecorations;
        public TextDecorations TextDecorations
        {
            get => _textDecorations;
            set
            {
                _textDecorations = value;
                OnPropertyChanged();
            }
        }
        private string _normalizedDate;
        public string NormalizedDate
        {
            get => _normalizedDate;
            set
            {
                _normalizedDate = value;
                OnPropertyChanged();
            }
        }

        public Task PurifyTask()
        {
            var task = new Task
            {
                Id = Id,
                TaskName = TaskName,
                TaskSort = TaskSort,
                CreateDt = CreateDt,
                DueDt = DueDt,
                IsCompleted = IsCompleted,
                IsArchived = IsArchived,
                TodoCategoryId = TodoCategoryId,
                TodoPriorityId = TodoPriorityId,
                SyncDt = SyncDt
            };

            return task;
        }
        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}