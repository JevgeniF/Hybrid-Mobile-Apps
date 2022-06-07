using Todorin.Helpers;
using Todorin.Views;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

[assembly: XamlCompilation(XamlCompilationOptions.Compile)]

namespace Todorin
{
    public partial class App
    {
        public App()
        {
            InitializeComponent();
            SetMainPage();
            RestoreTheme();
        }

        private static void RestoreTheme()
        {
            Current.UserAppTheme = Settings.UserTheme switch
            {
                "Dark" => OSAppTheme.Dark,
                "Light" => OSAppTheme.Light,
                _ => Current.UserAppTheme
            };
        }

        private void SetMainPage()
        {
            MainPage = !string.IsNullOrEmpty(Settings.JwtToken)
                ? new NavigationPage(new CategoriesPage())
                : new NavigationPage(new SignInPage());
        }

        protected override void OnStart()
        {
            // Handle when your app starts
        }

        protected override void OnSleep()
        {
            // Handle when your app sleeps
        }

        protected override void OnResume()
        {
            // Handle when your app resumes
        }
    }
}