using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Todorin.Models;

namespace Todorin.Services
{
    public static class ApiCategories
    {
        public static async Task<ObservableCollection<Category>> GetCategoriesAsync(string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);

            var json = await client.GetStringAsync(Constants.CategoriesUrl);

            var categories = JsonConvert.DeserializeObject<List<Category>>(json);
            if (categories == null) return null;
            var observableCollection = new ObservableCollection<Category>(categories); 
            return observableCollection;

        }

        public static async Task<HttpResponseMessage> PostCategoryAsync(Category category, string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);
            var json = JsonConvert.SerializeObject(category);
            HttpContent content = new StringContent(json);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

            var response = await client.PostAsync(Constants.CategoriesUrl, content);
            return response;
        }

        public static async Task<HttpResponseMessage> PutCategoryAsync(Category category, string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);
            var json = JsonConvert.SerializeObject(category);
            HttpContent content = new StringContent(json);
            content.Headers.ContentType = new MediaTypeHeaderValue("application/json");

            var response = await client.PutAsync(Constants.CategoriesUrl + category.Id, content);
            return response;
        }

        public static async Task<Category> GetCategoryByIdAsync(string id, string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);

            var json = await client.GetStringAsync(Constants.CategoriesUrl + id);

            var category = JsonConvert.DeserializeObject<Category>(json);
            return category;
        }

        public static async Task<HttpResponseMessage> DeleteCategoryAsync(string id, string jwtToken)
        {
            var client = new HttpClient();
            client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
                "Bearer", jwtToken);

            var response = await client.DeleteAsync(Constants.CategoriesUrl + id);
            return response;
        }
    }
}