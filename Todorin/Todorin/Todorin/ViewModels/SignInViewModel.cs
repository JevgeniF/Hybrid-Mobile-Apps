using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;
using System.Windows.Input;
using Newtonsoft.Json;
using Todorin.Helpers;
using Todorin.Models;
using Todorin.Services;
using Todorin.Views;
using Xamarin.Forms;

namespace Todorin.ViewModels
{
    public sealed class SignInViewModel : INotifyPropertyChanged
    {
        private bool _isVisibleError;
        private string _message;
        public string Email { get; set; }
        public string Password { get; set; }

        public string Message
        {
            get => _message;
            set
            {
                _message = value;
                OnPropertyChanged();
            }
        }

        public bool IsVisibleError
        {
            get => _isVisibleError;
            set
            {
                _isVisibleError = value;
                OnPropertyChanged();
            }
        }

        public ICommand SignInCommand => new Command(SignIn);

        public event PropertyChangedEventHandler PropertyChanged;

        private async void SignIn()
        {
            if (string.IsNullOrEmpty(Email) || !Regex.IsMatch(Email, Constants.RegexEmailPattern))
            {
                ShowError("Email has not valid pattern.");
            }
            else if (string.IsNullOrEmpty(Password) || !Regex.IsMatch(Password, Constants.RegexPasswordPattern))
            {
                ShowError("Password must have at least 6 chars: 1 uppercase, 1 number, 1 special.");
            }
            else
            {
                var response = await ApiAuthentication.SignInAsync(Email, Password);
                var content = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    var contentDynamic = JsonConvert.DeserializeObject<User>(content);
                    Settings.Email = Email;
                    if (contentDynamic == null) return;
                    var jwtToken = contentDynamic.Token;
                    Settings.JwtToken = jwtToken;
                    var firstName = contentDynamic.FirstName;
                    Settings.FirstName = firstName;
                    var lastName = contentDynamic.LastName;
                    Settings.LastName = lastName;
                    
                    await Application.Current.MainPage.Navigation.PushAsync(new CategoriesPage());
                }
                else
                {
                    var contentDynamic = JsonConvert.DeserializeObject<ErrorMessages>(content);
                    if (contentDynamic == null) return;
                    IsVisibleError = true;
                    Message = contentDynamic.ToString();
                }
            }
        }
        
        private void ShowError(string message)
        {
            Message = message;
            IsVisibleError = true;
            Device.StartTimer(TimeSpan.FromSeconds(3), () => {IsVisibleError = false;
                return false;
            });
        }

        private void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}