import "./globals.css";
import type { Metadata } from "next";
import Link from "next/link";

export const metadata: Metadata = {
  title: "Processo Legislativo — CMDC",
  description: "Sistema de Processo Legislativo da Camara Municipal de Duque de Caxias",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="pt-BR">
      <body>
        <header className="topbar">
          <Link href="/" className="brand">
            Processo Legislativo · CMDC
          </Link>
          <Link href="/proposicoes">Proposicoes</Link>
          <Link href="/proposicoes/nova">Nova</Link>
        </header>
        <main>{children}</main>
      </body>
    </html>
  );
}
