using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace Todorin.Models
{
    public sealed class Category : INotifyPropertyChanged
    {
        public Category()
        {
            CategorySort = 0;
        }

        public string Id { get; set; }
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

        private int CategorySort { get; set; }
        public string SyncDt { get; set; }
        private int _tasksCount;

        public int TasksCount
        {
            get => _tasksCount;
            set
            {
                _tasksCount = value;
                OnPropertyChanged();
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}