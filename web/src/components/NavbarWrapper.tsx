'use client';

import { usePathname } from 'next/navigation';
import Navbar from './Navbar';

export default function NavbarWrapper({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  
  // Routes where Navbar should be hidden
  const hideNavbarRoutes = ['/movie/', '/tv/'];
  const shouldHide = hideNavbarRoutes.some(route => pathname.startsWith(route));

  return (
    <>
      {!shouldHide && <Navbar />}
      <main className={shouldHide ? '' : 'pt-20'}>
        {children}
      </main>
    </>
  );
}
