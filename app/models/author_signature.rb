class AuthorSignature < Signature
  defaults :signature_role=> 'AUTHOR', :asserted_text=>SystemSetting.author_assert_text
end