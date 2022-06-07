using Todorin.Helpers;
using Xamarin.Forms.Xaml;

namespace Todorin.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SettingsPage
    {
        public SettingsPage()
        {
            InitializeComponent();
            LabelFirstName.Text = Settings.FirstName;
            LabelLastName.Text = Settings.LastName;
            LabelEmail.Text = Settings.Email;
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            LabelFirstName.Text = Settings.FirstName;
            LabelLastName.Text = Settings.LastName;
            LabelEmail.Text = Settings.Email;
        }
    }
}