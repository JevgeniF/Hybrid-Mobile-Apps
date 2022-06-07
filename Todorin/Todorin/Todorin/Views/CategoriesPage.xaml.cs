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
    public partial class CategoriesPage
    {
        private readonly CategoriesViewModel _categoriesViewModel = new CategoriesViewModel();

        public CategoriesPage()
        {
            BindingContext = _categoriesViewModel;
            InitializeComponent();
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            if (Application.Current.MainPage is NavigationPage navigationPage)
                navigationPage.SetAppThemeColor(
                    NavigationPage
                        .BarBackgroundColorProperty, Constants.CLightPrimaryColor, Constants.CDarkPrimaryColor);
            _categoriesViewModel.GetCategories();
        }

        private async void GoToAddNewCategory_OnClicked(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new AddNewCategoryPage());
        }

        private async void Edit_OnClicked(object sender, EventArgs e)
        {
            var mi = (MenuItem) sender;
            var category = await ApiCategories.GetCategoryByIdAsync(
                mi.CommandParameter.ToString(), Settings.JwtToken);
            await Navigation.PushAsync(new EditCategoryPage(category));
        }

        private async void Delete_OnClicked(object sender, EventArgs e)
        {
            var mi = (MenuItem) sender;
            var response = 
                await ApiCategories.DeleteCategoryAsync(mi.CommandParameter.ToString(), Settings.JwtToken);
            if (response.IsSuccessStatusCode)
            {
                _categoriesViewModel.Categories
                    .Remove(_categoriesViewModel.Categories
                        .Single(category => category.Id == mi.CommandParameter.ToString())
                    );
            }
            else _categoriesViewModel.ShowError("List is not empty. Delete todos first.");
        }

        private async void AllTodos_OnTapped(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new TasksPage(null));
        }

        private async void ListView_OnItemTapped(object sender, ItemTappedEventArgs e)
        {
            var category = e.Item as Category;
            await Navigation.PushAsync(new TasksPage(category));
        }
    }
}