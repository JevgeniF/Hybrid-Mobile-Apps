using System.Windows.Input;
using Todorin.Helpers;
using Todorin.Views;
using Xamarin.Forms;

namespace Todorin.ViewModels
{
    public class SettingsViewModel
    {
        public ICommand LightThemeCommand => new Command(() =>
        {
            Settings.UserTheme = "Light";
            Application.Current.UserAppTheme = OSAppTheme.Light;
        });
        
        public ICommand DarkThemeCommand => new Command(() =>
        {
            Settings.UserTheme = "Dark";
            Application.Current.UserAppTheme = OSAppTheme.Dark;
        });
        public ICommand SignOutCommand => new Command(SignOut);

        private static async void SignOut()
        {
            Settings.Email = "";
            Settings.FirstName = "";
            Settings.JwtToken = "";
            Settings.LastName = "";

            await Application.Current.MainPage.Navigation.PushAsync(new SignInPage());
        }
    }
}