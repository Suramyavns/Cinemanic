'use client';

import { motion } from 'framer-motion';
import { auth, googleProvider } from '@/lib/firebase';
import { signInWithPopup } from 'firebase/auth';
import Image from 'next/image';
import { LogIn } from 'lucide-react';

export default function WelcomeScreen() {
  const handleLogin = async () => {
    try {
      await signInWithPopup(auth, googleProvider);
    } catch (error) {
      console.error('Login failed:', error);
    }
  };

  return (
    <div className="fixed inset-0 z-500 bg-black flex flex-col items-center justify-end pb-20 px-6 overflow-hidden">
      {/* Background Cinematic Image */}
      <div className="absolute inset-0">
        <Image
          src="/assets/images/collage.jpg"
          alt="Welcome Background"
          fill
          className="object-cover opacity-60 scale-110 blur-[2px]"
          priority
        />
        <div className="absolute inset-0 bg-linear-to-t from-black via-black/40 to-transparent" />
      </div>

      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 1, ease: "easeOut" }}
        className="relative z-10 w-full max-w-md flex flex-col items-center text-center gap-8"
      >
        <div className="space-y-2 flex flex-col items-center justify-center">
          <motion.div
            initial={{ scale: 0.8, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ delay: 0.5, duration: 0.8 }}
          >
            <Image
              src="/assets/images/logo.png"
              alt="Cinemanic Logo"
              width={240}
              height={80}
              className="object-center"
            />
          </motion.div>
          <p className="text-white/70 text-lg font-medium leading-relaxed max-w-xs mx-auto">
            Unlimited Movies, TV Shows, and More.
          </p>
        </div>

        <motion.button
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
          onClick={handleLogin}
          className="w-full bg-blue-600 hover:bg-blue-700 text-white font-bold py-4 px-8 rounded-2xl shadow-2xl shadow-blue-600/30 transition-all flex items-center justify-center gap-3 text-lg"
        >
          <div className="bg-white p-1 rounded-full shrink-0">
             <Image src="/assets/images/google_logo.png" alt="Google" width={20} height={20} />
          </div>
          <span>Sign In with Google</span>
        </motion.button>

        <p className="text-white/40 text-xs mt-2">
          By continuing, you agree to our Terms & Privacy Policy
        </p>
      </motion.div>
    </div>
  );
}
