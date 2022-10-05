
// decryption key , the zero's should be replaced with the real key , preferable should be in size of Game.dll
extern unsigned char  mono_decryption_key[] =  {
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 };


int decryption_key_size()
{
     return  sizeof(mono_decryption_key);
}
