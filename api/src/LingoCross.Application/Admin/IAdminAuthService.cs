using LingoCross.Application.Admin.Dtos;

namespace LingoCross.Application.Admin;

/// <summary>
/// Tek-admin (env tabanlı) back office girişi. Kullanıcı tablosuna dokunmaz; başarıda Admin rollü
/// JWT döner.
/// </summary>
public interface IAdminAuthService
{
    /// <summary>
    /// E-posta + parolayı yapılandırılmış admin kimliğiyle sabit-zamanlı karşılaştırır. Admin
    /// yapılandırılmamışsa 503, eşleşmezse 401 fırlatır. Başarıda Admin rollü token döner.
    /// </summary>
    AdminLoginResult Login(string email, string password);
}
