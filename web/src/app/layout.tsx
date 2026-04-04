import NavbarWrapper from "@/components/NavbarWrapper";
import AuthGuard from "@/components/AuthGuard";
import { Analytics } from "@vercel/analytics/next";
import "./globals.css";

export const metadata = {
  title: "Cinemanic",
  description: "Stream movies and shows and engage with the community",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="antialiased bg-black text-white min-h-screen">
        <AuthGuard>
          <NavbarWrapper>
            {children}
          </NavbarWrapper>
        </AuthGuard>
        <Analytics />
      </body>
    </html>
  );
}